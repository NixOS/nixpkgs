{ stdenv
, fetchFromGitHub
, cmake
, rapidjson
, AppKit
, buildExamples ? false
}:

stdenv.mkDerivation rec {
  pname = "discord-rpc";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "discordapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "04cxhqdv5r92lrpnhxf8702a8iackdf3sfk1050z7pijbijiql2a";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rapidjson
  ] ++ stdenv.lib.optional stdenv.isDarwin AppKit;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=true"
    "-DBUILD_EXAMPLES=${stdenv.lib.boolToString buildExamples}"
  ];

  meta = with stdenv.lib; {
    description = "Official library to interface with the Discord client";
    homepage = "https://github.com/discordapp/discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
