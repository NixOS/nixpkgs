{ buildPythonPackage, fetchFromGitHub, lib, passlib, pytestCheckHook, setuptools
, setuptools-git, twine, webtest }:

buildPythonPackage rec {
  pname = "pypiserver";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1z5rsmqgin98m6ihy1ww42fxxr6jb4hzldn8vlc9ssv7sawdz8vz";
  };

  nativeBuildInputs = [ setuptools-git ];

  propagatedBuildInputs = [ setuptools ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [ passlib pytestCheckHook twine webtest ];

  # These tests try to use the network
  disabledTests = [
    "test_pipInstall_openOk"
    "test_pipInstall_authedOk"
    "test_hash_algos"
  ];

  pythonImportsCheck = [ "pypiserver" ];

  meta = with lib; {
    homepage = "https://github.com/pypiserver/pypiserver";
    description = "Minimal PyPI server for use with pip/easy_install";
    license = with licenses; [ mit zlib ];
    maintainers = [ maintainers.austinbutler ];
  };
}
