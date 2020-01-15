{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
}:

buildPythonPackage rec {
  pname = "nmigen-boards";
  version = "unstable-2019-08-30";
  realVersion = lib.substring 0 7 src.rev;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen-boards";
    rev = "3b80b3a3749ae8f123ff258a25e81bd21412aed4";
    sha256 = "01qynxip8bq23jfjc5wjd97vxfvhld2zb8sxphwf0zixrmmyaspi";
  };

  propagatedBuildInputs = [ nmigen ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'versioneer.get_version()' '"${realVersion}"'
  '';

  meta = with lib; {
    description = "Board and connector definitions for nMigen";
    homepage = https://github.com/m-labs/nmigen-boards;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
