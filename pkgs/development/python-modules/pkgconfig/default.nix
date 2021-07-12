{ lib, buildPythonPackage, fetchPypi, pkg-config }:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.5.4";

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
  ;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c34503829fd226822fd93c902b1cf275516908a023a24be0a02ba687f3a00399";
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
