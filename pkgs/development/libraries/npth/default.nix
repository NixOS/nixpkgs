{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "npth";
  version = "1.7";

  src = fetchurl {
    url = "mirror://gnupg/npth/npth-${version}.tar.bz2";
    sha256 = "sha256-hYn1aTe3XOM7KNMS/MvzArO3HsPzlF/eaqp0AnkUrQU=";
  };

  doCheck = true;

  meta = with lib; {
    description = "The New GNU Portable Threads Library";
    mainProgram = "npth-config";
    longDescription = ''
      This is a library to provide the GNU Pth API and thus a non-preemptive
      threads implementation.

      In contrast to GNU Pth is is based on the system's standard threads
      implementation.  This allows the use of libraries which are not
      compatible to GNU Pth.  Experience with a Windows Pth emulation showed
      that this is a solid way to provide a co-routine based framework.
    '';
    homepage = "http://www.gnupg.org";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
