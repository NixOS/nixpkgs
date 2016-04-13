{ stdenv, fetchurl, makeWrapper }:

let
  options = rec {
    x86_64-darwin = rec {
      version = "1.1.8";
      system = "x86-64-darwin";
      sha256 = "006pr88053wclvbjfjdypnbiw8wymbzdzi7a6kbkpdfn4zf5943j";
    };
    x86_64-linux = rec {
      version = "1.2.15";
      system = "x86-64-linux";
      sha256 = "1bpbfz9x2w73hy2kh8p0kd4m1p6pin90h2zycq52r3bbz8yv47aw";
    };
    i686-linux = rec {
      version = "1.2.7";
      system = "x86-linux";
      sha256 = "07f3bz4br280qvn85i088vpzj9wcz8wmwrf665ypqx181pz2ai3j";
    };
    armv7l-linux = rec {
      version = "1.2.14";
      system = "armhf-linux";
      sha256 = "0sp5445rbvms6qvzhld0kwwvydw51vq5iaf4kdqsf2d9jvaz3yx5";
    };
    armv6l-linux = armv7l-linux;
    x86_64-solaris = x86_64-linux;
    x86_64-freebsd = rec {
      version = "1.2.7";
      system = "x86-64-freebsd";
      sha256 = "14k42xiqd2rrim4pd5k5pjcrpkac09qnpynha8j1v4jngrvmw7y6";
    };
  };
  cfg = options.${stdenv.system};
in
stdenv.mkDerivation rec {
  name    = "sbcl-bootstrap-${version}";
  version = cfg.version;

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/sbcl-${version}-${cfg.system}-binary.tar.bz2";
    sha256 = cfg.sha256;
  };

  buildInputs = [ makeWrapper ];

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

  postFixup = stdenv.lib.optionalString (!stdenv.isArm && stdenv.isLinux) ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/share/sbcl/sbcl
  '';

  meta = with stdenv.lib; {
    description = "Lisp compiler";
    homepage = "http://www.sbcl.org";
    license = licenses.publicDomain; # and FreeBSD
    maintainers = [maintainers.raskin maintainers.tohl];
    platforms = attrNames options;
  };
}
