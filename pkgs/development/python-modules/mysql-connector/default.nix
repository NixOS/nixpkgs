{ lib, buildPythonPackage, fetchFromGitHub, python }:

let
  py = python;
in buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.24";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    sha256 = "1zb5wf65rnpbk0lw31i4piy0bq09hqa62gx7bh241zc5310zccc7";
  };

  patches = [
    # mysql-connector overrides MACOSX_DEPLOYMENT_TARGET to 11.
    # This makes the installation with nixpkgs fail. I suspect, that's
    # because stdenv.targetPlatform.darwinSdkVersion is (currently) set to
    # 10.12. The patch reverts
    # https://github.com/mysql/mysql-connector-python/commit/d1e89fd3d7391084cdf35b0806cb5d2a4b413654
    ./0001-Revert-Fix-MacOS-wheels-platform-tag.patch
  ];

  propagatedBuildInputs = with py.pkgs; [ protobuf dnspython ];

  # Tests are failing (TODO: unknown reason)
  # TypeError: __init__() missing 1 required positional argument: 'string'
  # But the library should be working as expected.
  doCheck = false;

  pythonImportsCheck = [ "mysql" ];

  meta = {
    description = "A MySQL driver";
    longDescription = ''
      A MySQL driver that does not depend on MySQL C client libraries and
      implements the DB API v2.0 specification.
    '';
    homepage = "https://github.com/mysql/mysql-connector-python";
    changelog = "https://raw.githubusercontent.com/mysql/mysql-connector-python/${version}/CHANGES.txt";
    license = [ lib.licenses.gpl2Only ];
    maintainers = with lib.maintainers; [ neosimsim turion ];
  };
}
