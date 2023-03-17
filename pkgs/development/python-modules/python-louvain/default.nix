{ lib
, fetchPypi
, buildPythonPackage
, fetchpatch
, networkx
, pandas
, scipy
, numpy }:

buildPythonPackage rec {
  pname = "python-louvain";
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-t7ot9QAv0o0+54mklTK6rRH+ZI5PIRfPB5jnUgodpWs=";
  };

  patches = [
    # Fix test_karate
    (fetchpatch {
      name = "fix-karate-test-networkx-2.7.patch";
      url = "https://github.com/taynaud/python-louvain/pull/95/commits/c95d767e72f580cb15319fe08d72d87c9976640b.patch";
      sha256 = "sha256-9oJ9YvKl2sI8oGhfyauNS+HT4kXsDt0L8S2owluWdj0=";
    })
  ];

  propagatedBuildInputs = [ networkx numpy ];

  pythonImportsCheck = [ "community" ];

  nativeCheckInputs = [ pandas scipy ];

  meta = with lib; {
    homepage = "https://github.com/taynaud/python-louvain";
    description = "Louvain Community Detection";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
