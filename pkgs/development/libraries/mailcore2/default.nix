{ stdenv, lib, fetchFromGitHub, cmake, libetpan, icu, cyrus_sasl, libctemplate
, libuchardet, pkgconfig, glib, libtidy, libxml2, libuuid, openssl
}:

stdenv.mkDerivation rec {
  name = "mailcore2-${version}";

  version = "0.5.1";

  src = fetchFromGitHub {
    owner  = "MailCore";
    repo   = "mailcore2";
    rev    = version;
    sha256 = "1k0l59cdk8np4pff1my07dp7ivf3nchlhcpvm9xizp0my9rqgbxb";
  };

  buildInputs = [
    libetpan cmake icu cyrus_sasl libctemplate libuchardet pkgconfig glib
    libtidy libxml2 libuuid openssl
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
       --replace "tidy/tidy.h" "tidy.h" \
       --replace "/usr/include/tidy" "${libtidy}/include" \
       --replace "/usr/include/libxml2" "${libxml2.dev}/include/libxml2"
    substituteInPlace src/core/basetypes/MCHTMLCleaner.cpp \
      --replace buffio.h tidybuffio.h
>>>>>>> master
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  installPhase = ''
    mkdir $out
    cp -r src/include $out

    mkdir $out/lib
    cp src/libMailCore.so $out/lib
  '';

  doCheck = true;
  checkPhase = ''
    (
      cd unittest
      LD_LIBRARY_PATH="$(cd ../src; pwd)" TZ=PST8PDT ./unittestcpp ../../unittest/data
    )
  '';

  meta = with lib; {
    description = "A simple and asynchronous API to work with e-mail protocols IMAP, POP and SMTP";
    homepage    = http://libmailcore.com;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan ];
  };
}
