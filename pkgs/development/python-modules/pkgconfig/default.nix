{ lib, buildPythonPackage, fetchPypi, pkg-config }:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.5.5";

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
  ;

  src = fetchPypi {
    inherit pname version;
    sha256 = "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899";
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
