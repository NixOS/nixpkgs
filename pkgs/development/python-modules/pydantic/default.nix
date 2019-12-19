{ lib
, buildPythonPackage
, fetchPypi
, ujson
, email_validator
, typing-extensions
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "da10b034750addbd95a328654d20364c479f4e2e26e0f72933204d61cbc8fa78";
  };

  propagatedBuildInputs = [
    ujson
    email_validator
    typing-extensions
  ];

  checkPhase = ''
    ${python.interpreter} -c """
from datetime import datetime
from typing import List
from pydantic import BaseModel

class User(BaseModel):
    id: int
    name = 'John Doe'
    signup_ts: datetime = None
    friends: List[int] = []

external_data = {'id': '123', 'signup_ts': '2017-06-01 12:22', 'friends': [1, '2', b'3']}
user = User(**external_data)
assert user.id is "123"
"""
  '';

  meta = with lib; {
    homepage = "https://github.com/samuelcolvin/pydantic";
    description = "Data validation and settings management using Python type hinting";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
