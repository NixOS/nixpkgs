{ lib, buildPythonPackage, fetchFromGitHub
, pytest, isPy3k, pyqt5, pyqt ? pyqt5
, fetchpatch
}:

buildPythonPackage rec {
  pname = "quamash";
  version = "0.6.1";
  format = "setuptools";

  disabled = !isPy3k;

  # No tests in PyPi tarball
  src = fetchFromGitHub {
    owner = "harvimt";
    repo = "quamash";
    rev = "version-${version}";
    sha256 = "117rp9r4lz0kfz4dmmpa35hp6nhbh6b4xq0jmgvqm68g9hwdxmqa";
  };

  patches = [
    # add 3.10 compatibility, merged remove on next update
    (fetchpatch {
      url = "https://github.com/harvimt/quamash/pull/126/commits/1e9047bec739dbc9d6ab337fc1a111a8b1090244.patch";
      hash = "sha256-6gomY82AOKkrt32SEBKnRugzhnC5FAyKDs6K5xaxnRM=";
    })
  ];

  propagatedBuildInputs = [ pyqt ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
     pytest -k 'test_qthreadexec.py' # the others cause the test execution to be aborted, I think because of asyncio
  '';

  meta = with lib; {
    description = "Implementation of the PEP 3156 event-loop (asyncio) api using the Qt Event-Loop";
    homepage = "https://github.com/harvimt/quamash";
    license = licenses.bsd2;
    maintainers = with maintainers; [ borisbabic ];
  };
}
