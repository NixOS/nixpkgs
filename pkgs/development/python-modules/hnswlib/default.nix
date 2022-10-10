{ buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, pybind11
, lib
, numpy
}: buildPythonPackage rec {
  pname = "hnswlib";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "nmslib";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j6olj6I5rzLvUCaMU5UCjJlSzHOZipIISKM+NsJcQM0=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeBuildInputs = [ pybind11 ];

  checkInputs = [ unittestCheckHook ];

  unittestFlags = [ "-v" "-s" "python_bindings/tests" ];

  meta = with lib; {
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/nmslib/hnswlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ehllie ];
  };
}
