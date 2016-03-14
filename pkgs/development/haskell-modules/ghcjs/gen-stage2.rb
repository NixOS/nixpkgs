#!/usr/bin/env ruby

require 'pathname'

# from boot.yaml in ghcjs/ghcjs
stage2_packages = [
  "boot/async",
  "boot/aeson",
  "boot/attoparsec",
  "boot/case-insensitive",
  "boot/dlist",
  "boot/extensible-exceptions",
  "boot/hashable",
  "boot/mtl",
  "boot/old-time",
  "boot/parallel",
  "boot/scientific",
  "boot/stm",
  "boot/syb",
  "boot/text",
  "boot/unordered-containers",
  "boot/vector",
  "ghcjs/ghcjs-base",
  # not listed under stage2, but needed when "quick booting".
  "boot/cabal/Cabal"
]

nixpkgs = File.expand_path("../../../../..", __FILE__)
boot = `nix-build #{nixpkgs} -A haskell.packages.ghcjs.ghc.ghcjsBoot`.chomp

out = "".dup
out << "{ ghcjsBoot, callPackage }:\n"
out << "\n"
out << "{\n"

stage2_packages.each do |package|
  name = Pathname.new(package).basename
  nix = `cabal2nix file://#{boot}/#{package}  --jailbreak`
  nix.sub!(/src =.*?$/, "src = \"${ghcjsBoot}/#{package}\";")
  nix.sub!("libraryHaskellDepends", "doCheck = false;\n  libraryHaskellDepends")
  # cabal2nix somehow generates the deps for 'text' as if it had selected flag
  # 'integer-simple' (despite not passing the flag within the generated
  # expression). We want integer-gmp instead.
  nix.gsub!(/integer-simple/, "integer-gmp")
  nix = nix.split("\n").join("\n      ")

  out << "  #{name} = callPackage\n"
  out << "    (#{nix}) {};\n"
end

out << "}"

puts out
