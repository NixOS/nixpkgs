{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deap";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zAHemJLfp9G8mAPasoiS/q0XfwGCyB20c2CiQOrXeP8=";
  };

  propagatedBuildInputs = [ matplotlib numpy ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A novel evolutionary computation framework for rapid prototyping and testing of ideas";
    homepage = "https://github.com/DEAP/deap";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ getpsyched psyanticy ];
  };
}
