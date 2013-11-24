{ stdenv, fetchurl
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
, libyaml, yamlSupport ? true
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}-p${patchLevel}";
  
  name = "ruby-${version}";
  
  src = fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/1.9/${name}.tar.bz2";
    sha256 = "0w1avj8qfskvkgvrjxxc1cxjm14bf1v60ipvcl5q3zpn9k14k2cx";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = (ops cursesSupport [ ncurses readline ] )
    ++ (op docSupport groff )
    ++ (op zlibSupport zlib)
    ++ (op opensslSupport openssl)
    ++ (op gdbmSupport gdbm)
    ++ (op yamlSupport libyaml)
    # Looks like ruby fails to build on darwin without readline even if curses
    # support is not enabled, so add readline to the build inputs if curses
    # support is disabled (if it's enabled, we already have it) and we're
    # running on darwin
    ++ (op (!cursesSupport && stdenv.isDarwin) readline);

  enableParallelBuilding = true;
  patches = [ ./ruby19-parallel-install.patch
	      ./bitperfect-rdoc.patch
  ];

  configureFlags = [ "--enable-shared" "--enable-pthread" ]
    # on darwin, we have /usr/include/tk.h -- so the configure script detects
    # that tk is installed
    ++ ( if stdenv.isDarwin then [ "--with-out-ext=tk " ] else [ ]);

  installFlags = stdenv.lib.optionalString docSupport "install-doc";
  # Bundler tries to create this directory
  postInstall = "mkdir -pv $out/${passthru.gemPath}";

  meta = {
    license     = "Ruby";
    homepage    = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.all;
  };

  passthru = rec {
    majorVersion = "1.9";
    minorVersion = "3";
    patchLevel = "429";
    libPath = "lib/ruby/${majorVersion}";
    gemPath = "lib/ruby/gems/${majorVersion}";
  };
}
