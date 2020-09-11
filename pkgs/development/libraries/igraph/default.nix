{ stdenv, lib, fetchFromGitHub,
  pkgconfig, autoreconfHook,
  flex, yacc, zlib, libxml2 }:

stdenv.mkDerivation rec {
  pname = "igraph";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = pname;
    rev = version;
    sha256 = "015yh9s19lmxm7l1ld8adlsqh1lrmzicl801saixdwl9w05hfva4";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ flex yacc zlib libxml2 ];

  # Normally, igraph wants us to call bootstrap.sh, which will call
  # tools/getversion.sh. Instead, we're going to put the version directly
  # where igraph wants, and then let autoreconfHook do the rest of the
  # bootstrap. ~ C.
  postPatch = ''
    echo "${version}" > IGRAPH_VERSION
  '';

  doCheck = true;

  meta = {
    description = "The network analysis package";
    homepage = "https://igraph.org/";
    license = lib.licenses.gpl2;
    # NB: Known to fail tests on aarch64.
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
