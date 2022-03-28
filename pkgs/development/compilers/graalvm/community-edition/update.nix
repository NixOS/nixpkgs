{
  javaVersion,
  graalVersion,
  config,
  sourcesFilename,
  lib,
  writeScript,
  jq,
  runtimeShell
}:

let
  # getArchString :: String -> String
  getArchString = nixArchString:
    {
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-amd64";
      "x86_64-darwin" = "darwin-amd64";
    }.${nixArchString};


  # getProductSuffix :: String -> String
    getProductSuffix = productName:
      let suffixes = {
        "graalvm-ce" = ".tar.gz";
        "native-image-installable-svm" = ".jar";
        "ruby-installable-svm" = ".jar";
        "wasm-installable-svm" = ".jar";
        "python-installable-svm" = ".jar";
      };
      in
      suffixes.${productName};

  # getProductSuffix :: String -> String
    getProductBaseUrl = productName:
      let baseUrls = {
        "graalvm-ce" = "https://github.com/graalvm/graalvm-ce-builds/releases/download";
        "native-image-installable-svm" = "https://github.com/graalvm/graalvm-ce-builds/releases/download";
        "ruby-installable-svm" = "https://github.com/oracle/truffleruby/releases/download";
        "wasm-installable-svm" = "https://github.com/graalvm/graalvm-ce-builds/releases/download";
        "python-installable-svm" = "https://github.com/graalvm/graalpython/releases/download";
      };
      in
      baseUrls.${productName};

  # generateUrl :: AttrSet -> String
    generateUrl = { arch, graalVersion, product, javaVersion }:

    let baseUrl = getProductBaseUrl product;
    in
    "${baseUrl}/vm-${graalVersion}/${product}-${javaVersion}-${arch}-${graalVersion}${getProductSuffix product}";

  # downloadSha256 :: AttrSet -> String
    downloadSha256 = args@{ arch, graalVersion, product, javaVersion }:
      let url = generateUrl args + ".sha256";
      in
        builtins.readFile (builtins.fetchurl url);

  # cartesianZipListsWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    cartesianZipListsWith = f: fst: snd:
      let cartesianProduct = lib.cartesianProductOfSets { a = fst; b = snd; };
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
       let attrNames  = [ "product" "javaVersion" "graalVersion" ];
           attrValues = lib.splitString "_" product_javaVersion_graalVersion;
        in zipListsToAttrs attrNames attrValues;

  # genUrlAndSha256 :: String -> String -> AttrSet
    genUrlAndSha256 = arch: product_javaVersion_graalVersion:
      let
        productJavaVersionGraalVersion =
          (genProductJavaVersionGraalVersionAttrSet product_javaVersion_graalVersion)
            // { inherit arch; };
        url = generateUrl productJavaVersionGraalVersion;
        sha256 = downloadSha256 productJavaVersionGraalVersion;
      in
      {
        ${arch} = {
          ${product_javaVersion_graalVersion} = {
            inherit sha256 url;
          };
        };
      };

  # genArchProductVersionPairs :: String -> AttrSet -> [AttrSet]
    genArchProductVersionList = javaGraalVersion: archProducts:
      let
        arch = archProducts.arch;
        products = archProducts.products;
        productJavaGraalVersionList =
          cartesianZipListsWith (a: b: a + "_" + b) products [ javaGraalVersion ];
      in
        cartesianZipListsWith (genUrlAndSha256) [ arch ] productJavaGraalVersionList;


  # genSources :: String -> String -> AttrSet -> Path String
    genSources = graalVersion: javaVersion: config:
      let
        javaGraalVersion = javaVersion + "_" + graalVersion; # java17_20.2.0.2
        archProducts = builtins.attrValues config;
        sourcesList = builtins.concatMap (genArchProductVersionList javaGraalVersion) archProducts;
        sourcesAttr = builtins.foldl' (lib.recursiveUpdate) {} sourcesList;
      in
        builtins.toFile "sources.json" (builtins.toJSON sourcesAttr);

    sourcesJson = genSources graalVersion javaVersion config;

in
  writeScript "update-graal.sh" ''
    #!${runtimeShell}
    set -o errexit
    set -o nounset
    set -o pipefail

    export PATH="${lib.makeBinPath [ jq ]}:$PATH"

     jq . ${sourcesJson} > ${lib.strings.escapeShellArg ./.}/${sourcesFilename}
  ''
