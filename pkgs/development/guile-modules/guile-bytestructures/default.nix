{ lib
, mkGuileModule
, fetchFromGitHub
, libffi
, libgit2
}:

mkGuileModule rec {
  pname = "guile-bytestructures";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "TaylanUB";
    repo = "scheme-bytestructures";
    rev = "v${version}";
    sha256 = "1wf7b2kwhbijc6ppbh56skcfz29ra72ahf7q5i438bdg0ns3jl7b";
  };

  meta = with lib; {
    description = "Structured access library to bytevector contents for Guile";
    homepage = "https://github.com/TaylanUB/scheme-bytestructures";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
