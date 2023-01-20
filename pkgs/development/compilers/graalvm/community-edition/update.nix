{ config
, defaultVersion
, forceUpdate
, gnused
, graalVersion
, javaVersion
, jq
, lib
, name
, sourcesPath
, writeShellScript
}:

/*
  How to  use:
  run `nix-shell maintainers/scripts/update.nix --argstr package graalvmXX-ce`
  to update the graalvmXX-ce-sources.json file.
  E.g: nix-shell maintainers/scripts/update.nix --argstr package graalvm17-ce

  Basic idea:
  If we know the platform, product, javaVersion and graalVersion
  we can create the url. This leads to the following json structure:
  {
  "platform/arch1": {
  "product1|javaVersion|graalVersion": { "sha256": "...", "url": "..."},
  "product2|javaVersion|graalVersion": { "sha256": "...", "url": "..."},
  ...
  },
  "platform/arch2": {
  ...
  }
  }
*/

let
  separator = "|";

  # isDev :: String -> Boolean
  isDev = version:
    lib.hasInfix "dev" version;

  # getLatestVersion :: String -> String
  getLatestVersion = currentVersion:
    let
      dev = if isDev currentVersion then "dev-" else "";
      url = "https://api.github.com/repos/graalvm/graalvm-ce-${dev}builds/releases/latest";
      file = builtins.fetchurl url;
      json = builtins.fromJSON (builtins.readFile file);
    in
    lib.removePrefix "vm-" json.tag_name;

  # getArchString :: String -> String
  getArchString = nixArchString:
    {
      "aarch64-linux" = "linux-aarch64";
      "aarch64-darwin" = "darwin-aarch64";
      "x86_64-linux" = "linux-amd64";
      "x86_64-darwin" = "darwin-amd64";
    }.${nixArchString};


  # getProductSuffix :: String -> String
  getProductSuffix = productName:
    {
      "graalvm-ce" = ".tar.gz";
      "native-image-installable-svm" = ".jar";
      "ruby-installable-svm" = ".jar";
      "wasm-installable-svm" = ".jar";
      "python-installable-svm" = ".jar";
      "js-installable-svm" = ".jar";
    }.${productName};

  # getProductSuffix :: String -> String
  getProductBaseUrl = productName:
    {
      "graalvm-ce" = "https://github.com/graalvm/graalvm-ce-builds/releases/download";
      "native-image-installable-svm" = "https://github.com/graalvm/graalvm-ce-builds/releases/download";
      "ruby-installable-svm" = "https://github.com/oracle/truffleruby/releases/download";
      "wasm-installable-svm" = "https://github.com/graalvm/graalvm-ce-builds/releases/download";
      "python-installable-svm" = "https://github.com/graalvm/graalpython/releases/download";
      "js-installable-svm" = "https://github.com/oracle/graaljs/releases/download";
    }.${productName};

  # getDevUrl :: String
  getDevUrl = { arch, graalVersion, product, javaVersion }:
    let
      baseUrl = https://github.com/graalvm/graalvm-ce-dev-builds/releases/download;
    in
    "${baseUrl}/${graalVersion}/${product}-${javaVersion}-${arch}-dev${getProductSuffix product}";

  # getReleaseUrl :: AttrSet -> String
  getReleaseUrl = { arch, graalVersion, product, javaVersion }:
    let baseUrl = getProductBaseUrl product;
    in
    "${baseUrl}/vm-${graalVersion}/${product}-${javaVersion}-${arch}-${graalVersion}${getProductSuffix product}";

  # getUrl :: AttrSet -> String
  getUrl = args@{ arch, graalVersion, product, javaVersion }:
    if isDev graalVersion
    then getDevUrl args
    else getReleaseUrl args;

  # computeSha256 :: String -> String
  computeSha256 = url:
    builtins.hashFile "sha256" (builtins.fetchurl url);

  # downloadSha256 :: String -> String
  downloadSha256 = url:
    let sha256Url = url + ".sha256";
    in
    builtins.readFile (builtins.fetchurl sha256Url);

  # getSha256 :: String -> String -> String
  getSha256 = graalVersion: url:
    if isDev graalVersion
    then computeSha256 url
    else downloadSha256 url;

  # cartesianZipListsWith :: (a -> b -> c) -> [a] -> [b] -> [c]
  cartesianZipListsWith = f: fst: snd:
    let
      cartesianProduct = lib.cartesianProductOfSets { a = fst; b = snd; };
      fst' = builtins.catAttrs "a" cartesianProduct;
      snd' = builtins.catAttrs "b" cartesianProduct;
    in
    lib.zipListsWith f fst' snd';

  # zipListsToAttrs :: [a] -> [b] -> AttrSet
  zipListsToAttrs = names: values:
    lib.listToAttrs (
      lib.zipListsWith (name: value: { inherit name value; }) names values
    );

  # genProductJavaVersionGraalVersionAttrSet :: String -> AttrSet
  genProductJavaVersionGraalVersionAttrSet = product_javaVersion_graalVersion:
    let
      attrNames = [ "product" "javaVersion" "graalVersion" ];
      attrValues = lib.splitString separator product_javaVersion_graalVersion;
    in
    zipListsToAttrs attrNames attrValues;

  # genUrlAndSha256 :: String -> String -> AttrSet
  genUrlAndSha256 = arch: product_javaVersion_graalVersion:
    let
      productJavaVersionGraalVersion =
        (genProductJavaVersionGraalVersionAttrSet product_javaVersion_graalVersion)
        // { inherit arch; };
      url = getUrl productJavaVersionGraalVersion;
      sha256 = getSha256 productJavaVersionGraalVersion.graalVersion url;
    in
    {
      ${arch} = {
        ${product_javaVersion_graalVersion} = {
          inherit sha256 url;
        };
      };
    };

  # genArchProductVersionPairs :: String -> -> String -> AttrSet -> [AttrSet]
  genArchProductVersionList = javaVersion: graalVersion: archProducts:
    let
      arch = archProducts.arch;
      products = archProducts.products;
      javaGraalVersion = javaVersion + separator + (getLatestVersion (archProducts.version or graalVersion));
      productJavaGraalVersionList =
        cartesianZipListsWith (a: b: a + separator + b)
          products [ javaGraalVersion ];
    in
    cartesianZipListsWith (genUrlAndSha256) [ arch ] productJavaGraalVersionList;


  # genSources :: String -> String -> AttrSet -> Path String
  genSources = javaVersion: defaultVersion: config:
    let
      archProducts = builtins.attrValues config;
      sourcesList = builtins.concatMap (genArchProductVersionList javaVersion defaultVersion) archProducts;
      sourcesAttr = builtins.foldl' (lib.recursiveUpdate) { } sourcesList;
    in
    builtins.toFile "sources.json" (builtins.toJSON sourcesAttr);

  # isNew :: String -> String -> Boolean
  isNew = newVersion: currentVersion:
    {
      "-1" = false;
      "0" = false;
      "1" = true;
    }.${builtins.toString (builtins.compareVersions newVersion currentVersion)};

  newVersion = getLatestVersion graalVersion;
  sourcesJson = genSources javaVersion defaultVersion config;
  sourcesJsonPath = lib.strings.escapeShellArg sourcesPath;

  # versionKeyInDefaultNix String -> String
  versionKeyInDefaultNix = graalVersion:
    if isDev graalVersion
    then "${name}-dev-version"
    else "${name}-release-version";

  /*
    updateScriptText :: String -> String -> String
    Writes the json file and updates the version in default.nix using sed
    because update-source-version does not work srcs.
  */
  updateScriptText = newVersion: currentVersion:

    if (forceUpdate || (isNew newVersion currentVersion))
    then
      let
        versionKey = versionKeyInDefaultNix currentVersion;
      in
      ''
        echo "New version found. Updating ${currentVersion} -> ${newVersion}".
        export PATH="${lib.makeBinPath [ jq gnused ]}:$PATH"
        jq . ${sourcesJson} > ${sourcesJsonPath}
        sed -i 's|${versionKey} = "${currentVersion}";|${versionKey} = "${newVersion}";|' \
          ${lib.strings.escapeShellArg ./default.nix}
      ''
    else ''echo "No new version found. Skip updating."'';

in
writeShellScript "update-graal.sh" ''
  set -o errexit
  set -o nounset
  set -o pipefail

  ${updateScriptText newVersion graalVersion}
''
