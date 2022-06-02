{ stdenv
, lib
, buildPythonPackage
, django
, dnspython
, fetchFromGitHub
, protobuf
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.29";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    hash = "sha256-X0qiXNYkNoR00ESUdByPj4dPnEnjLyopm25lm1JvkAk=";
  };

  patches = [
    # mysql-connector overrides MACOSX_DEPLOYMENT_TARGET to 11.
    # This makes the installation with nixpkgs fail. I suspect, that's
    # because stdenv.targetPlatform.darwinSdkVersion is (currently) set to
    # 10.12. The patch reverts
    # https://github.com/mysql/mysql-connector-python/commit/d1e89fd3d7391084cdf35b0806cb5d2a4b413654
    ./0001-Revert-Fix-MacOS-wheels-platform-tag.patch
  ];

  propagatedBuildInputs = [
    dnspython
    protobuf
  ];

  pythonImportsCheck = [
    "mysql"
  ];

  # Tests require a running MySQL instance
  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A MySQL driver";
    longDescription = ''
      A MySQL driver that does not depend on MySQL C client libraries and
      implements the DB API v2.0 specification.
    '';
    homepage = "https://github.com/mysql/mysql-connector-python";
    changelog = "https://raw.githubusercontent.com/mysql/mysql-connector-python/${version}/CHANGES.txt";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ neosimsim turion ];
  };
}
