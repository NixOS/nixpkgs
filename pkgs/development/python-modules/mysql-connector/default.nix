{ stdenv
, lib
, buildPythonPackage
, django
, dnspython
, fetchFromGitHub
, protobuf
, pythonOlder
<<<<<<< HEAD
, mysql80
, openssl
, pkgs
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mysql-connector";
<<<<<<< HEAD
  version = "8.0.33";
=======
  version = "8.0.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

<<<<<<< HEAD
  setupPyBuildFlags = [
    "--with-mysql-capi=\"${mysql80}\""
    "--with-openssl-include-dir=\"${openssl.dev}/include\""
    "--with-openssl-lib-dir=\"${lib.getLib openssl}/lib\""
    "-L \"${lib.getLib pkgs.zstd}/lib:${lib.getLib mysql80}/lib\""
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-GtMq7E2qBqFu54hjUotzPyxScTKXNdEQcmgHnS7lBhc=";
=======
    hash = "sha256-X0qiXNYkNoR00ESUdByPj4dPnEnjLyopm25lm1JvkAk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # mysql-connector overrides MACOSX_DEPLOYMENT_TARGET to 11.
    # This makes the installation with nixpkgs fail. I suspect, that's
    # because stdenv.targetPlatform.darwinSdkVersion is (currently) set to
    # 10.12. The patch reverts
    # https://github.com/mysql/mysql-connector-python/commit/d1e89fd3d7391084cdf35b0806cb5d2a4b413654
    ./0001-Revert-Fix-MacOS-wheels-platform-tag.patch
<<<<<<< HEAD
  ];

  nativeBuildInputs = [
    mysql80
  ];


  propagatedBuildInputs = [
    dnspython
    protobuf
    mysql80
    openssl
    pkgs.zstd
=======

    # Allow for clang to be used to build native extensions
    (fetchpatch {
      url = "https://github.com/mysql/mysql-connector-python/commit/fd24ce9dc8c60cc446a8e69458f7851d047c7831.patch";
      hash = "sha256-WvU1iB53MavCsksKCjGvUl7R3Ww/38alxxMVzjpr5Xg=";
    })
  ];

  propagatedBuildInputs = [
    dnspython
    protobuf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "mysql"
  ];

  # Tests require a running MySQL instance
  doCheck = false;

  meta = with lib; {
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
