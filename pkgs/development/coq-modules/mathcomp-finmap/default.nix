{
  coq,
  mkCoqDerivation,
  mathcomp-boot,
  lib,
  version ? null,
}:

mkCoqDerivation {

  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "finmap";
  owner = "math-comp";
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
      [ coq.coq-version mathcomp-boot.version ]
      [
        (case (range "8.20" "9.1") (range "2.3" "2.5") "2.2.2")
        (case (range "8.20" "9.1") (range "2.3" "2.4") "2.2.0")
        (case (range "8.16" "9.0") (range "2.0" "2.3") "2.1.0")
        (case (range "8.16" "8.18") (range "2.0" "2.1") "2.0.0")
        (case (range "8.13" "8.20") (range "1.12" "1.19") "1.5.2")
        (case (isGe "8.10") (range "1.11" "1.17") "1.5.1")
        (case (range "8.7" "8.11") "1.11.0" "1.5.0")
        (case (isEq "8.11") (range "1.8" "1.10") "1.4.0+coq-8.11")
        (case (range "8.7" "8.11.0") (range "1.8" "1.10") "1.4.0")
        (case (range "8.7" "8.11.0") (range "1.8" "1.10") "1.3.4")
        (case (range "8.7" "8.9") "1.7.0" "1.1.0")
        (case (range "8.6" "8.7") (range "1.6.1" "1.7") "1.0.0")
      ]
      null;
  release = {
    "2.2.2".sha256 = "sha256-G5fSdx4MhOXtQ2H8lpyK5FuIbWAZNc7vRL3hcYmGA2o=";
    "2.2.0".sha256 = "sha256-oDQEZOutrJxmN8FvzovUIhqw0mwc8Ej7thrieJrW8BY=";
    "2.1.0".sha256 = "sha256-gh0cnhdVDyo+D5zdtxLc10kGKQLQ3ITzHnMC45mCtpY=";
    "2.0.0".sha256 = "sha256-0Wr1ZUYVuZH74vawO4EZlZ+K3kq+s1xEz/BfzyKj+wk=";
    "1.5.2".sha256 = "sha256-0KmmSjc2AlUo6BKr9RZ4FjL9wlGISlTGU0X1Eu7l4sw=";
    "1.5.1".sha256 = "0ryfml4pf1dfya16d8ma80favasmrygvspvb923n06kfw9v986j7";
    "1.5.0".sha256 = "0vx9n1fi23592b3hv5p5ycy7mxc8qh1y5q05aksfwbzkk5zjkwnq";
    "1.4.1".sha256 = "0kx4nx24dml1igk0w0qijmw221r5bgxhwhl5qicnxp7ab3c35s8p";
    "1.4.0+coq-8.11".sha256 = "1fd00ihyx0kzq5fblh9vr8s5mr1kg7p6pk11c4gr8svl1n69ppmb";
    "1.4.0".sha256 = "0mp82mcmrs424ff1vj3cvd8353r9vcap027h3p0iprr1vkkwjbzd";
    "1.3.4".sha256 = "0f5a62ljhixy5d7gsnwd66gf054l26k3m79fb8nz40i2mgp6l9ii";
    "1.2.1".sha256 = "0jryb5dq8js3imbmwrxignlk5zh8gwfb1wr4b1s7jbwz410vp7zf";
    "1.1.0".sha256 = "05df59v3na8jhpsfp7hq3niam6asgcaipg2wngnzxzqnl86srp2a";
    "1.0.0".sha256 = "0sah7k9qm8sw17cgd02f0x84hki8vj8kdz7h15i7rmz08rj0whpa";
  };

  propagatedBuildInputs = [ mathcomp-boot ];

  meta = {
    description = "Finset and finmap library";
    license = lib.licenses.cecill-b;
  };
}
