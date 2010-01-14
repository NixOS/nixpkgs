{runCommand, php, appendLines ? "", prefixPhpRecommended ? true} :


/*

NixOS: see apache-httpd/default.nix's phpIni option

to enable Xdebug append these lines:
  ''
      zend_extension="${pkgs.phpXdebug}/lib/xdebug.so"
      zend_extension_ts="${pkgs.phpXdebug}/lib/xdebug.so"
      zend_extension_debug="${pkgs.phpXdebug}/lib/xdebug.so"
      xdebug.remote_enable=true
      xdebug.remote_host=127.0.0.1
      xdebug.remote_port=9000
      xdebug.remote_handler=dbgp
      xdebug.profiler_enable=0
      xdebug.profiler_output_dir="/tmp/xdebug"
      xdebug.remote_mode=req
  ''

to make php's mail() function work add
  ''
   ; Needed for PHP's mail() function.
   sendmail_path = sendmail -t -i
  ''
*/


runCommand "php.ini"
  {
    inherit php appendLines prefixPhpRecommended;
  }
  ''
    [ -z "$prefixPhpRecommended" ] || {
      {
      echo "# PHP RECOMMENDED INI START"
      cat $php/etc/php-recommended.ini
      echo "# PHP RECOMMENDED INI END"
      } >> $out
    }
    echo "$appendLines" >> $out
  ''
