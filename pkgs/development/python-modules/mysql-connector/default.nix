{
  stdenv,
  lib,
  buildPythonPackage,
  django,
  dnspython,
  fetchFromGitHub,
  protobuf,
  pythonOlder,
  mysql80,
  openssl,
  pkgs,
}:

buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.33";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  setupPyBuildFlags = [
    "--with-mysql-capi=\"${mysql80}\""
    "--with-openssl-include-dir=\"${openssl.dev}/include\""
    "--with-openssl-lib-dir=\"${lib.getLib openssl}/lib\""
    "-L \"${lib.getLib pkgs.zstd}/lib:${lib.getLib mysql80}/lib\""
  ];

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    hash = "sha256-GtMq7E2qBqFu54hjUotzPyxScTKXNdEQcmgHnS7lBhc=";
  };

  patches = [
    # mysql-connector overrides MACOSX_DEPLOYMENT_TARGET to 11.
    # This makes the installation with nixpkgs fail. I suspect, that's
    # because stdenv.hostPlatform.darwinSdkVersion is (currently) set to
    # 10.12. The patch reverts
    # https://github.com/mysql/mysql-connector-python/commit/d1e89fd3d7391084cdf35b0806cb5d2a4b413654
    ./0001-Revert-Fix-MacOS-wheels-platform-tag.patch
  ];

  nativeBuildInputs = [ mysql80 ];

  propagatedBuildInputs = [
    dnspython
    protobuf
    mysql80
    openssl
    pkgs.zstd
  ];

  pythonImportsCheck = [ "mysql" ];

  # Tests require a running MySQL instance
  doCheck = false;

  meta = with lib; {
    description = "MySQL driver";
    longDescription = ''
      A MySQL driver that does not depend on MySQL C client libraries and
      implements the DB API v2.0 specification.
    '';
    homepage = "https://github.com/mysql/mysql-connector-python";
    changelog = "https://raw.githubusercontent.com/mysql/mysql-connector-python/${version}/CHANGES.txt";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      neosimsim
      turion
    ];
  };
}
