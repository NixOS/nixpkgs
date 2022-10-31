{ stdenv
, lib
, buildPythonPackage

, austin ? null  # Avoid circular dependency between austin / austin-python.
, fetchFromGitHub
, hatchling
, hatch-vcs
, poetry-core
, protobuf
, psutil
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, toml
}:

buildPythonPackage rec {
  pname = "austin-python";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p403n1x87";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ddzv17lxj+59NMEe13eUNUmuzezrLY5q08+2Rrocp9E=";
  };

  postPatch = ''
    # Fixup paths to dependencies usually found in PATH.
    substituteInPlace austin/tools/resolve.py \
      --replace '"addr2line"' '"${stdenv.cc.bintools}/bin/addr2line"'
    ${if austin == null then ""
      else ''
        substituteInPlace austin/__init__.py \
          --replace 'return self.BINARY' 'return "${austin}/bin/austin"'
      ''}
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    protobuf
    psutil
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  doCheck = austin != null;

  pythonRelaxDeps = [ "protobuf" ];

  disabledTests = [
    # With the way we patch austin-python to find austin (from the Nix store
    # instead of $PATH) the tests always find a proper austin binary, causing
    # them to fail. This is fine, it just means the error condition this is
    # trying to test cannot happen with Nix.
    "test_async_invalid_binary"
    "test_simple_invalid_binary"
    "test_threaded_invalid_binary"

    # https://github.com/P403n1x87/austin-python/pull/14
    "test_threaded_bad_options"
  ];

  pythonImportsCheck = [ "austin" ];

  meta = with lib; {
    description = "Python wrapper for Austin, the CPython frame stack sampler";
    homepage = "https://github.com/P403n1x87/austin-python";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
