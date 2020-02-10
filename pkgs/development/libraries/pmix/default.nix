{ stdenv, fetchurl, buildEnv, hwloc, libevent }:

let

  version = "3.1.4";

  libevent-comb = buildEnv{
    inherit (libevent.out) name;
    paths = [ libevent.dev libevent.out ];
  };

in stdenv.mkDerivation rec {
  pname = "pmix";
  inherit version;

  src = fetchurl {
    url = "https://github.com/openpmix/openpmix/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "1q4y18yq7w4mqcmvmazhbgzw6kr4ndxz8m35avbcgdv4fzznwbwq";
  };

  buildInputs = with stdenv; [ libevent-comb hwloc ];

  configureFlags = with stdenv; [
    "--with-libevent=${libevent-comb}"
    "--with-hwloc=${hwloc.dev}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://pmix.org;
    description = "Open source PMIx implementation";
    maintainers = with maintainers; [ ikervagyok ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
