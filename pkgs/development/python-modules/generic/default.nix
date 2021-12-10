{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.0.1";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
     owner = "gaphor";
     repo = "generic";
     rev = "1.0.1";
     sha256 = "1y82b032khzcwpny0qy6vl3dhfj02amj1h1i6wl6mnqkd4yvfyiq";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/generic";
    license = licenses.bsdOriginal;
  };
}
