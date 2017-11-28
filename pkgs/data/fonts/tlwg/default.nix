{ stdenv, fetchgit, autoconf, automake, git, fontforge }:

stdenv.mkDerivation rec {
  name = "tlwg-${version}";
  version = "0.6.4";

  src = fetchgit {
   url = "https://github.com/tlwg/fonts-tlwg";
   rev = "v${version}";
   sha256 = "1agvarmcy467y1nk670j3vffgx7ihld4z1l2fpyhbybzqwdp708k";
   leaveDotGit = true;
  };

  preConfigure = ''
    ./autogen.sh
  '';

  buildInputs = [ autoconf automake fontforge git ];

  meta = with stdenv.lib; {
    description = "A collection of Thai scalable fonts available under free licenses";
    homepage = https://linux.thai.net/projects/fonts-tlwg;
    license = [ licenses.gpl2 licenses.publicDomain licenses.lppl13c licenses.free ];
    platforms = platforms.unix;
    maintainers = [ maintainers.yrashk ];
  };
}
