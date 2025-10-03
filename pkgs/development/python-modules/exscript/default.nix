{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  configparser,
  paramiko,
  pycryptodomex,
  setuptools,
}:
buildPythonPackage {
  pname = "exscript";
  version = "2.6-unstable-2025-08-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "knipknap";
    repo = "exscript";
    rev = "6fd60076e2b56875faf65ea63de272aba223d40b";
    hash = "sha256-EUkE4BK17NoQJenIibfz4junYiJ4uVHRK4xqfCae/AQ=";
  };

  build-tools = [ setuptools ];

  dependencies = [
    configparser
    paramiko
    pycryptodomex
    setuptools
  ];

  pythonRemoveDeps = [ "future" ];

  postPatch = ''
    substituteInPlace Exscript/version.py \
      --replace-fail "DEVELOPMENT" "2.6"

    substituteInPlace Exscript/servers/sshd.py \
      --replace-fail "base64.decodestring" "base64.decodebytes"

    substituteInPlace Exscript/emulators/command.py \
      --replace-fail "from past.builtins import execfile" "" \
      --replace-fail "execfile(filename, args)" "exec(open(filename).read(), args)"

    substituteInPlace \
      Exscript/logger.py \
      Exscript/protocols/dummy.py \
      Exscript/protocols/protocol.py \
      Exscript/protocols/telnet.py \
      Exscript/protocols/telnetlib.py \
      Exscript/servers/httpd.py \
      Exscript/util/collections.py \
      Exscript/util/file.py \
      Exscript/util/interact.py \
      Exscript/util/url.py \
      tests/Exscript/protocols/ProtocolTest.py \
      tests/Exscript/workqueue/JobTest.py \
      tests/Exscript/workqueue/PipelineTest.py \
        --replace-fail "from future import standard_library" "" \
        --replace-fail "standard_library.install_aliases()" ""
  '';

  # Included tests require internet
  doCheck = false;
  pythonImportsCheck = [ "Exscript" ];

  meta = {
    description = "Automating Telnet and SSH";
    homepage = "https://github.com/knipknap/exscript";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
}
