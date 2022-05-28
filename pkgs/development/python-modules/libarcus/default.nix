{ lib, buildPythonPackage, python, fetchFromGitHub
, fetchpatch
, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "5.0.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "0f871vx14hyjnqiqik36zmf7mi7dvzf08cqpryk8g1acj9mkh3ag";
  };

  patches = [
    # Fix build against protobuf 3.18+
    # https://github.com/Ultimaker/libArcus/issues/121
    (fetchpatch {
      url = "https://raw.githubusercontent.com/coryan/vcpkg/f69b85aa403b04e7d442c90db3418d484e44024f/ports/arcus/0001-fix-protobuf-deprecated.patch";
      sha256 = "0bqj7pxzpwsamknd6gadj419x6mwx8wnlfzg4zqn6cax3cmasjb2";
    })
  ];

  disabled = pythonOlder "3.4";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  cmakeFlags = [
    # The upstream code checks for an exact python version and errors out
    # if we don't have that and do not pass `Python_VERSION` explicitly:
    #     https://github.com/Ultimaker/libArcus/commit/f867664e46144fed9ae9c4f4e6a29192163fb884#diff-1e7de1ae2d059d21e1dd75d5812d5a34b0222cef273b7c3a2af62eb747f9d20aR31
    "-DPython_VERSION=${python.pythonVersion}"
    # Set install location to not be the global Python install dir
    # (which is read-only in the nix store); see:
    "-DPython_SITELIB_LOCAL=${placeholder "out"}/${python.sitePackages}"
  ];

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
