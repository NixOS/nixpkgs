{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, attrs
, linkify-it-py
, psutil
, pytest-benchmark
, pytest-regressions
, typing-extensions
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GA7P2I8N+i2ISsVgx58zyhrfKMcZ7pL4X9T/trbsr1Y=";
  };

  patches = [
    (fetchpatch {
      # :arrow_up: UPGRADE: attrs -> v21 (#165)
      # https://github.com/executablebooks/markdown-it-py/pull/165
      url = "https://github.com/executablebooks/markdown-it-py/commit/78381ffe1a651741594dc93e693b761422512fa2.patch";
      sha256 = "1kxhblpi4sycrs3rv50achr8g0wlgq33abg2acra26l736hlsya1";
    })
  ];

  propagatedBuildInputs = [ attrs linkify-it-py ]
    ++ lib.optional (pythonOlder "3.8") typing-extensions;

  checkInputs = [
    psutil
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
  ];
  pytestImportsCheck = [ "markdown_it" ];

  meta = with lib; {
    description = "Markdown parser done right";
    homepage = "https://markdown-it-py.readthedocs.io/en/latest";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
