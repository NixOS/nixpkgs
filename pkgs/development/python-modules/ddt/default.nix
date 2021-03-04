{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, six, pyyaml, mock
, pytestCheckHook
, enum34
, isPy3k
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0595e70d074e5777771a45709e99e9d215552fb1076443a25fad6b23d8bf38da";
  };

  patches = [
    # fix tests with recent PyYAML, https://github.com/datadriventests/ddt/pull/96
    (fetchpatch {
      url = "https://github.com/datadriventests/ddt/commit/97f0a2315736e50f1b34a015447cd751da66ecb6.patch";
      sha256 = "1g7l5h7m7s4yqfxlygrg7nnhb9xhz1drjld64ssi3fbsmn7klf0a";
    })
  ];

  checkInputs = [ six pyyaml mock pytestCheckHook ];

  propagatedBuildInputs = lib.optionals (!isPy3k) [
    enum34
  ];

  meta = with lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = "https://github.com/txels/ddt";
    license = licenses.mit;
  };

}
