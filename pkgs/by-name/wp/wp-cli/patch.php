<?php

# Usage: php -d phar.readonly=0 patch.php /path/to/input.phar <entry> /path/to/ca-bundle.crt

$input = realpath($argv[1]);
$entry = $argv[2];
$replacement = realpath($argv[3]);

echo "Patching PHAR archive:\n";
echo "    Input: {$input}\n";
echo "    Entry: {$entry}\n";
echo "    Replacement: {$replacement}\n";

$data = file_get_contents($replacement);

if ($data === false || trim($data) === '') {
    fwrite(STDERR, "cannot read ca bundle\n");
    exit(1);
}

$phar = new Phar($input);
if (!isset($phar[$entry])) {
    throw new RuntimeException("cannot find entry {$entry} in phar");
}
$phar[$entry] = $data;

echo "Patch finished\n";
