{ lib, buildPythonPackage, fetchPypi, pkg-config }:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.5.2";

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
  ;

  src = fetchPypi {
    inherit pname version;
    sha256 = "38d612488f0633755a2e7a8acab6c01d20d63dbc31af75e2a9ac98a6f638ca94";
  };


  propagatedNativeBuildInputs = [ pkg-config ];

  doCheck = false;

  patches = [ ./executable.patch ];
  postPatch = ''
    substituteInPlace pkgconfig/pkgconfig.py --replace 'PKG_CONFIG_EXE = "pkg-config"' 'PKG_CONFIG_EXE = "${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"'
  '';

  pythonImportsCheck = [ "pkgconfig" ];

  meta = with lib; {
    description = "Interface Python with pkg-config";
    homepage = "https://github.com/matze/pkgconfig";
    license = licenses.mit;
  };
}
