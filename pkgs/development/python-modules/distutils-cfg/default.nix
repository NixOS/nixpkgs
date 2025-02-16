# global distutils configuration, see http://docs.python.org/2/install/index.html#distutils-configuration-files

{
  stdenv,
  python,
  writeText,
  extraCfg ? "",
  overrideCfg ? "",
}:

let
  distutilsCfg = writeText "distutils.cfg" (
    if overrideCfg != "" then
      overrideCfg
    else
      ''
        [easy_install]

        # don't allow network connections during build to ensure purity
        allow-hosts = None

        # make sure we always unzip installed packages otherwise setup hooks won't work
        zip_ok = 0

        ${extraCfg}
      ''
  );
in
stdenv.mkDerivation {
  name = "${python.libPrefix}-distutils.cfg";

  buildInputs = [ python ];

  dontUnpack = true;

  installPhase = ''
    dest="$out/${python.sitePackages}/distutils"
    mkdir -p $dest
    ln -s ${python}/lib/${python.libPrefix}/distutils/* $dest
    ln -s ${distutilsCfg} $dest/distutils.cfg
  '';
}
