#!/usr/bin/env ruby

# Take those from https://github.com/elm-lang/elm-platform/blob/master/installers/BuildFromSource.hs
$elm_version = "0.15.1"
$elm_packages = { "elm-compiler" => "0.15.1",
                  "elm-package" => "0.5.1",
                  "elm-make" => "0.2",
                  "elm-reactor" => "0.3.2",
                  "elm-repl" => "0.4.2"
                }

for pkg, ver in $elm_packages
  system "cabal2nix https://github.com/elm-lang/#{pkg} --revision refs/tags/#{ver} --jailbreak > #{pkg}.nix"
end

File.open("release.nix", 'w') do |file|
  file.puts "{"
  file.puts "  version = \"#{$elm_version}\";"
  file.puts "  packages = {"
  for pkg, ver in $elm_packages
    file.puts "    #{pkg} = callPackage ./#{pkg}.nix { };"
  end
  file.puts "  };"
  file.puts "}"
end
