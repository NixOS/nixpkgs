{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "openvr";
  version = "1.16.8";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "openvr";
    rev = "v${version}";
    sha256 = "sha256-QSQjmJi4IW0/WJ7tHZkASTlBjdzg/xTq+AA7CkznKVY=";
  };

  patches = [
    (fetchpatch {
      name = "fix-includes.patch";
      url = "https://github.com/ValveSoftware/openvr/pull/1524/commits/ccdcd5a741bead75f60325f97d59ccdc4f082bac.patch";
      sha256 = "sha256-H+J+PC+w16ylVURNRT8grQOigsjuqmgSGCJtmQ+tM8s=";
    })
    (fetchpatch {
      name = "add-include-stdarg.h-to-strtools_public.cpp.patch";
      url = "https://github.com/ValveSoftware/openvr/pull/1542/commits/f9a141cc8c875ab820fa783a81255712296a75bb.patch";
      sha256 = "sha256-4oMGXdScte6O5/YEHdoLofjYG5Q8Rj6SJNfMwWg7x58=";
    })
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with lib; {
    description = "OpenVR SDK";
    longDescription = ''
      OpenVR is an API and runtime that allows access to VR hardware from multiple vendors
      without requiring that applications have specific knowledge of the hardware they are
      targeting. This repository is an SDK that contains the API and samples. The runtime
      is under SteamVR in Tools on Steam.
    '';
    license = licenses.bsd3;
    homepage = "http://steamvr.com";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
