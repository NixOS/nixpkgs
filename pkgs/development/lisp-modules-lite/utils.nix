# Copyright © 2022  Hraban Luyat
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

{
  pkgs
  , lib

  , lispDerivation
}:

with lib;

rec {
  a = attrsets;
  b = builtins;
  l = lists;
  s = strings;
  t = trivial;

  # The obvious signature for pipe. Who wants ltr? (Clarification: putting the
  # function pipeline first and the value second allows using rpipe in
  # point-free context. See other uses in this file.)
  rpipe = flip pipe;

  # Like foldr but without a nul-value. Doesn’t support actual ‘null’ in the
  # list because I don’t know how to make singletons (is that even possible in
  # Nix?) and because I don’t care.
  reduce = (op: seq:
    assert ! b.elem null seq; # N.B.: THIS MAKES IT STRICT!
    foldr (a: b: if b == null then a else (op a b)) null seq);

  # Create an empty string with the same context as the given string
  emptyCopyWithContext = str: s.addContextFrom str "";

  # Turn a derivation path into a context-less string. I suspect this isn’t in
  # the stdlib because this is a perversion of a low-level feature, not intended
  # for casual access in regular derivations.
  drvStrWithoutContext = rpipe [ toString b.getContext attrNames l.head ];

  # optionalKeys [ "a" "b" ] { a = 1; b = 2; c = 3; }
  # => { a = 1; b = 2; }
  # optionalKeys [ ] { a = 1; b = 2; c = 3; }
  # => { }
  # optionalKeys [ "a" "b" ] { a = 1; }
  # => { a = 1; }
  # optionalKeys [ "a" "b" ] { }
  # => { }
  optionalKeys = keys: a.filterAttrs (k: v: b.elem k keys);

  # Like the inverse of lists.remove but takes a test function instead of an
  # element
  # (a -> Bool) -> [a] -> [a]
  keepBy = f: foldr (a: b: l.optional (f a) a ++ b) [];

  # If argument is a function, call it with a constant value. Otherwise pass it
  # through.
  callIfFunc = val: f: if isFunction f then f val else f;

  flatMap = f: rpipe [ (map f) l.flatten ];

  normaliseStrings = rpipe [ l.unique l.naturalSort ];

  # This is a /nested/ union operation on attrsets: if you have e.g. a 2-layer
  # deep set (so a set of sets, so [ { String => { String => T } } ]), you can
  # pass 2 here to union them all.
  #
  # s = [
  #       { foo = { foo-bar = true ; foo-bim = true ; } ; }
  #       { foo = { foo-zom = true ; } ; bar = { bar-a = true ; } ; }
  # ]
  #
  # nestedUnion (_: true) 1 s
  # => { foo = true; bar = true; }
  # nestedUnion (_: true) 2 s
  # => {
  #      bar = { bar-a = true; };
  #      foo = { foo-bar = true; foo-bim = true; foo-zom = true; };
  #    }
  #
  # This convention is inspired by the representation of string context.
  #
  # The item function is a generator for the leaf nodes. It is passed the list
  # of values to union.
  #
  # Tip:
  # - nestedUnion head 1 [ a b ] == b // a
  # - nestedUnion tail 1 [ a b ] == a // b
  nestedUnion = item: n: sets:
    if n == 0
    then item sets
    else
      a.zipAttrsWith (_: vals: nestedUnion item (n - 1) vals) sets;

  getLispDeps = x: x.CL_SOURCE_REGISTRY or "";

  lisp-asdf-op = op: sys: "(asdf:${op} :${sys})";

  asdf = pkgs.fetchFromGitLab {
    name = "asdf-src";
    domain = "gitlab.common-lisp.net";
    owner = "asdf";
    repo = "asdf";
    rev = "3.3.6";
    sha256 = "sha256-GCmGUMLniPakjyL/D/aEI93Y6bBxjdR+zxXdSgc9NWo=";
  };

  asdfOpScript = op: name: systems: pkgs.writeText "${op}-${name}.lisp" ''
    (require :asdf)
    ${b.concatStringsSep "\n" (map (lisp-asdf-op op) systems)}
  '';

  # Internal convention for lisp: a function which takes a file and returns a
  # shell invocation calling that file, then exiting. External API: same, but
  # you can also just pass a derivation instead and it is converted, if
  # recognized. E.g. lisp = pkgs.sbcl.
  callLisp = lisp:
    if b.isFunction lisp
    then lisp
    else
      assert isDerivation lisp;
      {
        sbcl = file: ''"${lisp}/bin/sbcl" --script "${file}"'';
        ecl = file: ''"${lisp}/bin/ecl" --shell "${file}"'';
      }.${lisp.pname};

  # Get a context-less string representing this source derivation, come what
  # come may.
  derivPath = src: drvStrWithoutContext (
    if b.isPath src
    # Purely a developer ergonomics feature. Don’t rely on this for published
    # libs. It breaks pure eval.
    then b.path { path = src; }
    else src);

  isLispDeriv = x: x ? lispSystems;


  ## PACKAGE UTILS

  # Utility function that just adds some lisp dependencies to an existing
  # derivation.
  trimName = s.removeSuffix "-src";
}
