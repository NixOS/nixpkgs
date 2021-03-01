{ lib, buildPythonPackage, fetchPypi, pkg-config }:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.5.1";

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
  ;

  src = fetchPypi {
    inherit pname version;
    sha256 = "97bfe3d981bab675d5ea3ef259045d7919c93897db7d3b59d4e8593cba8d354f";
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
