{ lib
, buildPythonPackage
, fetchPypi
, pbr
, nose
}:

buildPythonPackage rec {
  pname = "lockfile";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799";
  };

  buildInputs = [ pbr ];
  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/pylockfile";
    description = "Platform-independent advisory file locking capability for Python applications";
    license = licenses.asl20;
  };
}
