{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dws4Z4LzgkkOGTS5LZn/MU8ZKr70n4PWocezsDhxeT4=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    homepage = "https://github.com/alexdlaird/pyngrok";
    description = "A Python wrapper for ngrok";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
