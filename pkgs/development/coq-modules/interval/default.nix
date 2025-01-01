{
  lib,
  mkCoqDerivation,
  autoconf,
  coq,
  coquelicot,
  flocq,
  mathcomp-ssreflect,
  mathcomp-fingroup,
  bignums ? null,
  gnuplot_qt,
  version ? null,
}:

mkCoqDerivation rec {
  pname = "interval";
  owner = "coqinterval";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.13" "8.20";
        out = "4.11.0";
      }
      {
        case = range "8.12" "8.19";
        out = "4.10.0";
      }
      {
        case = range "8.12" "8.18";
        out = "4.9.0";
      }
      {
        case = range "8.12" "8.17";
        out = "4.8.0";
      }
      {
        case = range "8.12" "8.16";
        out = "4.6.0";
      }
      {
        case = range "8.8" "8.16";
        out = "4.5.2";
      }
      {
        case = range "8.8" "8.12";
        out = "4.0.0";
      }
      {
        case = range "8.7" "8.11";
        out = "3.4.2";
      }
      {
        case = range "8.5" "8.6";
        out = "3.3.0";
      }
    ] null;
  release."4.11.0".sha256 = "sha256-vPwa4zSjyvxHLGDoNaBnHV2pb77dnQFbC50BL80fcvE=";
  release."4.10.0".sha256 = "sha256-MZJVoKGLXjDabdv9BuUSK1L9z1cubzC9cqVuWevKIXQ=";
  release."4.9.0".sha256 = "sha256-+5NppyQahcc1idGu/U3B+EIWuZz2L3/oY7dIJR6pitE=";
  release."4.8.1".sha256 = "sha256-gknZ3bA90YY2AvwfFsP5iMhohwkQ8G96mH+4st2RPDc=";
  release."4.8.0".sha256 = "sha256-YPQ1tuUgGixAVdQUJ9a3lZUNVgm2pKK3RKvl3m+/8rY=";
  release."4.7.0".sha256 = "sha256-Cel25w4BeaNqu9KAW3N2KYO2IGY0EOAK5FQ6VHBPmFQ=";
  release."4.6.1".sha256 = "sha256-ZZSxt8ksz0g6dl/LEido5qJXgsaxHrVLqkGUHu90+e0=";
  release."4.6.0".sha256 = "sha256-n9ECKnV0L6XYcIcbYyOJKwlbisz/RRbNW5YESHo07X0=";
  release."4.5.2".sha256 = "sha256-r0yE9pkC4EYlqsimxkdlCXevRcwKa3HGFZiUH+ueUY8=";
  release."4.5.1".sha256 = "sha256-5OxbSPdw/1FFENubulKSk6fEIEYSPCxfvMMgtgN6j6s=";
  release."4.3.0".sha256 = "sha256-k8DLC4HYYpHeEEgXUafS8jkaECqlM+/CoYaInmUTYko=";
  release."4.2.0".sha256 = "sha256-SD5thgpirs3wmZBICjXGpoefg9AAXyExb5t8tz3iZhE=";
  release."4.1.1".sha256 = "sha256-h2NJ6sZt1C/88v7W2xyuftEDoyRt3H6kqm5g2hc1aoU=";
  release."4.0.0".sha256 = "1hhih6zmid610l6c8z3x4yzdzw9jniyjiknd1vpkyb2rxvqm3gzp";
  release."3.4.2".sha256 = "07ngix32qarl3pjnm9d0vqc9fdrgm08gy7zp306hwxjyq7h1v7z0";
  release."3.3.0".sha256 = "0lz2hgggzn4cvklvm8rpaxvwaryf37i8mzqajqgdxdbd8f12acsz";
  releaseRev = v: "interval-${v}";

  nativeBuildInputs = [ autoconf ];
  propagatedBuildInputs =
    lib.optional (lib.versions.isGe "8.6" coq.coq-version) bignums
    ++ [
      coquelicot
      flocq
      mathcomp-ssreflect
      mathcomp-fingroup
    ]
    ++ lib.optionals (lib.versions.isGe "4.2.0" defaultVersion) [ gnuplot_qt ];
  useMelquiondRemake.logpath = "Interval";
  mlPlugin = true;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
  };
}
