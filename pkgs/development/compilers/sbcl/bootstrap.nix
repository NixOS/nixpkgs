{ lib, stdenv, fetchurl, makeWrapper }:

let
  options = rec {
    aarch64-darwin = {
      version = "2.1.2";
      system = "arm64-darwin";
      sha256 = "sha256-H0ALigXcWIypdA+fTf7jERscwbb7QIAfcoxCtGDh0RU=";
    };
    x86_64-darwin = {
      version = "2.2.9";
      system = "x86-64-darwin";
      sha256 = "sha256-b1BLkoLIOELAYBYA9eBmMgm1OxMxJewzNP96C9ADfKY=";
    };
    x86_64-linux = {
      version = "1.3.16";
      system = "x86-64-linux";
      sha256 = "0sq2dylwwyqfwkbdvcgqwz3vay9v895zpb0fyzsiwy31d1x9pr2s";
    };
    i686-linux = {
      version = "1.2.7";
      system = "x86-linux";
      sha256 = "07f3bz4br280qvn85i088vpzj9wcz8wmwrf665ypqx181pz2ai3j";
    };
    aarch64-linux = {
      version = "1.3.16";
      system = "arm64-linux";
      sha256 = "0q1brz9c49xgdljzfx8rpxxnlwhadxkcy5kg0mcd9wnxygind1cl";
    };
    armv7l-linux = {
      version = "1.2.14";
      system = "armhf-linux";
      sha256 = "0sp5445rbvms6qvzhld0kwwvydw51vq5iaf4kdqsf2d9jvaz3yx5";
    };
    armv6l-linux = armv7l-linux;
    x86_64-freebsd = {
      version = "1.2.7";
      system = "x86-64-freebsd";
      sha256 = "14k42xiqd2rrim4pd5k5pjcrpkac09qnpynha8j1v4jngrvmw7y6";
    };
    x86_64-solaris = {
      version = "1.2.7";
      system = "x86-64-solaris";
      sha256 = "05c12fmac4ha72k1ckl6i780rckd7jh4g5s5hiic7fjxnf1kx8d0";
    };
  };
  cfg = options.${stdenv.hostPlatform.system};
in
assert builtins.hasAttr stdenv.hostPlatform.system options;
stdenv.mkDerivation rec {
  pname = "sbcl-bootstrap";
  version = cfg.version;

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/sbcl-${version}-${cfg.system}-binary.tar.bz2";
    sha256 = cfg.sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p src/runtime/sbcl $out/bin

    mkdir -p $out/share/sbcl
    cp -p src/runtime/sbcl $out/share/sbcl
    cp -p output/sbcl.core $out/share/sbcl
    mkdir -p $out/bin
    makeWrapper $out/share/sbcl/sbcl $out/bin/sbcl \
      --add-flags "--core $out/share/sbcl/sbcl.core"
  '';

  postFixup = lib.optionalString (!stdenv.isAarch32 && stdenv.isLinux) ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/share/sbcl/sbcl
  '';

  meta = with lib; {
    description = "Lisp compiler";
    homepage = "http://www.sbcl.org";
    license = licenses.publicDomain; # and FreeBSD
    maintainers = lib.teams.lisp.members;
    platforms = attrNames options;
  };
}
