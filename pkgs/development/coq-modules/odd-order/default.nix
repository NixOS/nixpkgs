{
  lib,
  coq,
  mkCoqDerivation,
  mathcomp-character,
  version ? null,
}:

mkCoqDerivation {
  pname = "odd-order";
  owner = "math-comp";

  release."2.3.0".sha256 = "sha256-53FG8I9O+tsIlmaa9qy6VYyJNwWfGmhavKhbZ0VqAGc=";
  release."2.2.0".sha256 = "sha256-z0C7+wtY8NpoT8wYqHiy8mB2HPYAeJndzDmf7Bb0mg8=";
  release."2.1.0".sha256 = "sha256-TPlaQbO0yXEpUgy3rlCx/w1MSLECJk5tdU26fAGe48Q=";
  release."1.14.0".sha256 = "0iln70npkvixqyz469l6nry545a15jlaix532i1l7pzfkqqn6v68";
  release."1.13.0".sha256 = "sha256-EzNKR/JzM8T17sMhPhgZNs14e50X4dY3OwFi133IsT0=";
  release."1.12.0".sha256 = "sha256-omsfdc294CxKAHNMMeqJCcVimvyRCHgxcQ4NJOWSfNM=";
  releaseRev = v: "mathcomp-odd-order.${v}";

  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp-character.version ]
      [
        (case (range "9.0" "9.1") (range "2.5" "2.5") "2.3.0")
        (case (range "8.16" "9.1") (range "2.2.0" "2.4.0") "2.2.0")
        (case (range "8.16" "9.0") (range "2.1.0" "2.3.0") "2.1.0")
        (case (range "8.11" "8.16") (range "1.13.0" "1.15.0") "1.14.0")
        (case (range "8.10" "8.15") (range "1.12.0" "1.14.0") "1.13.0")
        (case (range "8.10" "8.14") (range "1.10.0" "1.12.0") "1.12.0")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp-character
  ];

  meta = with lib; {
    description = "Formal proof of the Odd Order Theorem";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
