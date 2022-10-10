{ buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, lib
, numpy
}: buildPythonPackage rec {
  pname = "hnswlib";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "nmslib";
    repo = pname;
    rev = "v${version}";
    hash = "";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ unittestCheckHook ];

  unittestFlags = [ "--start-directory" "python_bindings/tests" "--pattern" "*_test*.py" ];

  meta = with lib; {
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/nmslib/hnswlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ehllie ];
  };
}
