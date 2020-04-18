{ stdenv
, fetchFromGitHub
, makeWrapper
, mrustc
}:

let
  version = "0.9";
  tag = "v${version}";
in

stdenv.mkDerivation {
  inherit version;
  pname = "mrustc-minicargo";

  src = fetchFromGitHub {
    owner = "thepowersgang";
    repo = "mrustc";
    rev = tag;
    sha256 = "194ny7vsks5ygiw7d8yxjmp1qwigd71ilchis6xjl6bb2sj97rd2";
  };

  buildInputs = [ stdenv makeWrapper ];

  # Not actually required at build time, only at run time
  propagatedBuildInputs = [ mrustc ];

  buildPhase = "make -f minicargo.mk -j $NIX_BUILD_CORES tools/bin/minicargo";

  installPhase = ''
    mkdir -p $out/bin
    cp tools/bin/minicargo $out/bin

    # without it, minicargo defaults to "<minicargo_path>/../../bin/mrustc" 
    wrapProgram "$out/bin/minicargo" --set MRUSTC_PATH ${mrustc}/bin/mrustc
  '';

  meta = with stdenv.lib; {
    description = "A minimalist builder for Rust";
    longDescription = ''
      A minimalist builder for Rust, similar to Cargo but written in C++.
      Designed to work with mrustc to build Rust projects
      (like the Rust compiler itself).
    '';
    homepage = "https://github.com/thepowersgang/mrustc";
    license = licenses.mit;
    maintainers = [ maintainers.progval ];
    platforms = platforms.all;
  };
}
