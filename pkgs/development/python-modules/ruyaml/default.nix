{ lib
, buildPythonPackage
, distro
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ruyaml";
  version = "0.91.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gxvwry7n1gczxkjzyfrr3fammllkvnnamja4yln8xrg3n1h89al";
  };

  patches = [
    (fetchpatch {
      name = "remove-setuptools-scm-git-archive-from-setupcfg.patch";
      url = "https://github.com/pycontribs/ruyaml/commit/8922dd826cbb97b29e9826b00fb28a65d584e985.patch";
      includes = [ "setup.cfg" ];
      hash = "sha256-XAsORoPvYRElHswlZ4S377UwuJNCU1JuCz5iyFXoXOQ=";
    })

    # https://github.com/pycontribs/ruyaml/pull/107
    (fetchpatch {
      name = "remove-setuptools-scm-git-archive-from-pyproject.patch";
      url = "https://github.com/pycontribs/ruyaml/commit/4d605bf63f799696c8ba3c1f0a0f505db0ca33ce.patch";
      hash = "sha256-X6HWXBot5ZIo+odoSHhXMb03tgpQfRw/Ze8nFgH43ZI=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    distro
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "ruyaml"
  ];

  meta = with lib; {
    description = "YAML 1.2 loader/dumper package for Python";
    homepage = "https://ruyaml.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
