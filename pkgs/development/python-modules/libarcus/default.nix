{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  sip4,
  protobuf,
}:

buildPythonPackage rec {
  pname = "libarcus";
  version = "4.12.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    hash = "sha256-X33ptwYj9YkVWqUDPP+Ic+hoIb+rwsLdQXvHLA9z+3w=";
  };

  patches = [
    # Fix build against protobuf 3.18+
    # https://github.com/Ultimaker/libArcus/issues/121
    (fetchpatch {
      url = "https://raw.githubusercontent.com/coryan/vcpkg/f69b85aa403b04e7d442c90db3418d484e44024f/ports/arcus/0001-fix-protobuf-deprecated.patch";
      sha256 = "0bqj7pxzpwsamknd6gadj419x6mwx8wnlfzg4zqn6cax3cmasjb2";
    })
  ];

  propagatedBuildInputs = [ sip4 ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
  '';

  meta = with lib; {
    broken = true;
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      abbradar
      gebner
    ];
  };
}
