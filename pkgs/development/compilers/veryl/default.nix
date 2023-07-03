{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "veryl";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "veryl-v${version}";
    hash = "sha256-lTDJNtaNd+tY+HXyuja0eeY6ubNmuZ85mHYKRHlyR34=";
  };

  cargoHash = "sha256-xBeQA+18ox+yjKoCypSsebVwypHZNh6SYDJP8QwBhBY=";

  doCheck = false; # Impure due to file I/O

  meta = with lib; {
    description = "A modern hardware description language";
    homepage = "https://github.com/dalance/veryl";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ omasanori ];
  };
}
