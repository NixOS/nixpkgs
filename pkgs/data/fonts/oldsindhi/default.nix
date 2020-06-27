{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "oldsindhi";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/MihailJP/oldsindhi/releases/download/v${version}/OldSindhi-${version}.tar.xz";
    sha256 = "1pchv360ff0vgjl36rqn939mngspxlmzrz1n9py4hxpl6h8i9zs4";
  };

  meta = with lib; {
    homepage = "https://github.com/MihailJP/oldsindhi";
    description = "Free Sindhi Khudabadi font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = with licenses; [mit ofl];
    platforms = platforms.all;
  };
}
