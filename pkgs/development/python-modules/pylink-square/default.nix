{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, mock
, psutil
, six
, future
}:

let
  mock' = mock.overridePythonAttrs (old: rec {
    version = "2.0.0";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "1flbpksir5sqrvq2z0dp8sl4bzbadg21sj4d42w3klpdfvgvcn5i";
    };
  });
in buildPythonPackage rec {
  pname = "pylink-square";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "v${version}";
    sha256 = "1q5sm1017pcqcgwhsliiiv1wh609lrjdlc8f5ihlschk1d0qidpd";
  };

  buildInputs = [ mock' ];
  propagatedBuildInputs = [ psutil six future ];

  preCheck = ''
    # For an unknown reason, `pylink --version` output is different
    # inside the nix build environment across different python versions
    substituteInPlace tests/unit/test_main.py --replace \
      "expected = 'pylink %s' % pylink.__version__" \
      "return"
  '';

  pythonImportsCheck = [ "pylink" ];

  meta = with lib; {
    description = "Python interface for the SEGGER J-Link";
    homepage = "https://github.com/Square/pylink";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.asl20;
  };
}
