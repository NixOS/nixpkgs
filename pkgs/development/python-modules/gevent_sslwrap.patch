Index: b/gevent/ssl.py
===================================================================
--- a/gevent/ssl.py
+++ b/gevent/ssl.py
@@ -81,15 +81,14 @@ class SSLSocket(socket):
             self._sslobj = None
         else:
             # yes, create the SSL object
-            if ciphers is None:
-                self._sslobj = _ssl.sslwrap(self._sock, server_side,
-                                            keyfile, certfile,
-                                            cert_reqs, ssl_version, ca_certs)
-            else:
-                self._sslobj = _ssl.sslwrap(self._sock, server_side,
-                                            keyfile, certfile,
-                                            cert_reqs, ssl_version, ca_certs,
-                                            ciphers)
+            ctx = SSLContext(ssl_version)
+            if keyfile or certfile:
+                ctx.load_cert_chain(certfile, keyfile)
+            if ca_certs:
+                ctx.load_verify_locations(ca_certs)
+            if ciphers:
+                ctx.set_ciphers(ciphers)
+            self._sslobj = ctx._wrap_socket(self._sock, server_side=server_side)
             if do_handshake_on_connect:
                 self.do_handshake()
         self.keyfile = keyfile
