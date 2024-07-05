{ stdenv, lib, fetchFromGitHub, cmake, libetpan, icu, cyrus_sasl, libctemplate
, libuchardet, pkg-config, glib, html-tidy, libxml2, libuuid, openssl
, darwin
}:

stdenv.mkDerivation rec {
  pname = "mailcore2";

  version = "0.6.4";

  src = fetchFromGitHub {
    owner  = "MailCore";
    repo   = "mailcore2";
    rev    = version;
    sha256 = "0a69q11z194fdfwyazjyyylx57sqs9j4lz7jwh5qcws8syqgb23z";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    libetpan cyrus_sasl libctemplate libuchardet
    html-tidy libxml2 openssl
  ] ++ lib.optionals stdenv.isLinux [
    glib
    icu
    libuuid
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
       --replace " icule iculx" "" \
       --replace "tidy/tidy.h" "tidy.h" \
       --replace "/usr/include/tidy" "${html-tidy}/include" \
       --replace "/usr/include/libxml2" "${libxml2.dev}/include/libxml2"
    substituteInPlace src/core/basetypes/MCHTMLCleaner.cpp \
      --replace buffio.h tidybuffio.h
    substituteInPlace src/core/basetypes/MCString.cpp \
      --replace "xmlErrorPtr" "const xmlError *"
  '' + lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace src/core/basetypes/MCICUTypes.h \
      --replace "__CHAR16_TYPE__ UChar" "char16_t UChar"
  '';

  cmakeFlags = lib.optionals (!stdenv.isDarwin) [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  installPhase = ''
    mkdir $out
    cp -r src/include $out

    mkdir $out/lib
    cp src/libMailCore.* $out/lib
  '';

  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    (
      cd unittest
      TZ=PST8PDT ./unittestcpp ../../unittest/data
    )
  '';

  meta = with lib; {
    description = "Simple and asynchronous API to work with e-mail protocols IMAP, POP and SMTP";
    homepage    = "http://libmailcore.com";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms   = platforms.unix;
  };
}
