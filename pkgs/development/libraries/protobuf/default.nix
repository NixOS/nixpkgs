{ stdenv, fetchFromGitHub, autoconf, automake, libtool, zlib, gtest }:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf";
    rev = version;
    sha256 = "03df8zvx2sry3jz2x4pi3l32qyfqa7w8kj8jdbz30nzy0h7aa070";
  };

  postPatch = ''
    sed -i -e '/gtest/d' Makefile.am
    sed -i \
      -e 's!\$(top_\(build\|src\)dir)/gtest!${gtest}!g' \
      -e 's/\(libgtest[^.]*\.\)la/\1a/g' \
      src/Makefile.am
  '';

  buildInputs = [ zlib autoconf automake libtool gtest ];

  preConfigure = "autoreconf -vfi";

  doCheck = true;

  meta = {
    description = "Protocol Buffers - Google's data interchange format";

    longDescription = ''
      Protocol Buffers are a way of encoding structured data in an
      efficient yet extensible format. Google uses Protocol Buffers for
      almost all of its internal RPC protocols and file formats.
    '';

    license = stdenv.lib.licenses.bsd3;

    homepage = "https://developers.google.com/protocol-buffers/";
  };
}
