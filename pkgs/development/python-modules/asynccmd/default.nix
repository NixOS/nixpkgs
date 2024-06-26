{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "asynccmd";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "valentinmk";
    repo = pname;
    rev = version;
    sha256 = "02sa0k0zgwv0y8k00pd1yh4x7k7xqhdikk2c0avpih1204lcw26h";
  };

  patches = [
    # Deprecation of asyncio.Task.all_tasks(), https://github.com/valentinmk/asynccmd/pull/2
    (fetchpatch {
      name = "deprecation-python-38.patch";
      url = "https://github.com/valentinmk/asynccmd/commit/12afa60ac07db17e96755e266061f2c88cb545ff.patch";
      sha256 = "0l6sk93gj51qqrpw01a8iiyz14k6dd2z68vr9l9w9vx76l8725yf";
    })
  ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "asynccmd" ];

  meta = with lib; {
    description = "Asyncio implementation of Cmd Python library";
    homepage = "https://github.com/valentinmk/asynccmd";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
