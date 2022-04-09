{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "flatdict";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = pname;
    rev = version;
    hash = "sha256-qH4MMDSXf92BPavnRdCka6lRoWZg+2KnHpHA8kt5JaM=";
  };

  pythonImportsCheck = [
    "flatdict"
  ];

  meta = with lib; {
    description = "Python module for interacting with nested dicts as a single level dict with delimited keys";
    homepage = "https://github.com/gmr/flatdict";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
