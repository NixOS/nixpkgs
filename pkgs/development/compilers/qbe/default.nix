{ lib, stdenv
, fetchgit
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2020-10-05";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "496c069405cd79aed968f59dd5a5f92d1f96809f";
    sha256 = "1vpszl77j9mnw8r0p9l23k8nxbnz31lgii7v3mai130nbpjsjsdf";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
