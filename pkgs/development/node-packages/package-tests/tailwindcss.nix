{
  runCommand,
  tailwindcss,
  nodePackages,
}:

let

  inherit (tailwindcss) packageName version;

  tailwindcssInput = builtins.toFile "input.css" ''
    @tailwind base;
    @tailwind components;
    @tailwind utilities;
  '';

  tailwindcssWithPlugins = tailwindcss.overrideAttrs (oldAttrs: {
    plugins = [
      nodePackages."@tailwindcss/typography"
    ];
  });

  tailwindcssWithPluginsConfig = builtins.toFile "tailwind.config.js" ''
    module.exports = {
      content: ["./with-typography.input"],
      plugins: [
        require('@tailwindcss/typography'),
      ],
    }
  '';

in

runCommand "${packageName}-tests" { meta.timeout = 60; } ''
  mkdir $out

  # Ensure CLI runs
  ${tailwindcss}/bin/tailwind --help > /dev/null
  ${tailwindcss}/bin/tailwindcss --help > /dev/null

  # Ensure CLI with plugins runs
  echo '"ml-4 prose"' > ./with-typography.input
  ${tailwindcssWithPlugins}/bin/tailwind \
    --config ${tailwindcssWithPluginsConfig} \
    --input ${tailwindcssInput} \
    --output $out/with-typography.css

  grep -q ml-4 $out/with-typography.css
  grep -q prose $out/with-typography.css
''
